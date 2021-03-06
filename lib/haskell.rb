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

module Haskell
  class << self
    def assert_arg_type(meth, args, klasses)
      args.each_with_index do |arg, i|
        if wrong_type?(arg, klasses[i])
          raise ArgumentError, "Wrong type of argument, type of #{arg.inspect} should be #{klasses[i]}"
        end
      end
    end

    def assert_trn_type(meth, rtn, klass)
      if wrong_type?(rtn, klass)
        raise TypeError, "Expected #{meth} to return #{klass} but got #{rtn.inspect} instead"
      end
    end

    def wrong_type?(obj, klass)
      !(obj.is_a?(klass) || klass == Any)
    end
  end
end
