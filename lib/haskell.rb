require 'pry'
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
