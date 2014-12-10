<<<<<<< HEAD
require 'pry'
=======
# Builtin Contracts
class  Any;     end
module Boolean; end
TrueClass.send(:include, Boolean)
FalseClass.send(:include, Boolean)

class Module
  private
  def __haskell__
    prepend (@__haskell__ = Module.new) unless @__haskell__
    @__haskell__
  end
  
  # @param [Hash] {method_name: [ArgClass1, ArgClass2, ... ArgClassn => RtnClass]}
  def typesig(hash)
    meth = hash.keys.first
    *arg_types, type_pair = hash.values.first

    __haskell__.send(:define_method, meth) do |*args, &block|
      ::Haskell.assert_arg_type(meth, args, arg_types << type_pair.keys.first)
      rtn = super(*args, &block)
      ::Haskell.assert_trn_type(meth, rtn, type_pair.values.first)
      rtn
    end
    self
  end
end

>>>>>>> e97f0f35ab7f4f36d51b6c314e988136e32de375
module Haskell
  class << self
    def init_sandbox!
      file_path = File.expand_path('../', __FILE__)
      $sandbox_path = "#{file_path}/haskell_executing_sandbox"
      FileUtils.mkdir($sandbox_path) unless Dir.exist?($sandbox_path)
      $tmp_hs_file_path = "#{$sandbox_path}/tmp.hs"
    end

    def execute(hs_code)
      File.write($tmp_hs_file_path, executable_code(hs_code))
      Kernel.system("ghc #{$tmp_hs_file_path}")
      `#{$sandbox_path}/tmp`.gsub(/\n\z/, '')
    end

    def executable_code(hs_code)
<<-HASKELL_CODE
module Main where
#{hs_code.gsub(/\n */, "\n")}
main = do putStrLn $ show result
HASKELL_CODE
    end
  end
end

module Kernel
  def haskell
    Haskell.init_sandbox!
    Haskell.execute(yield)
  rescue
    raise "Something wrong... https://github.com/gogotanaka/Haskell/issues"
  ensure
    FileUtils.rm_rf($sandbox_path)
  end
end
