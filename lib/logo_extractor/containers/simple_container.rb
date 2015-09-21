
module LogoExtractor
  module Containers
    # Class skeleton for encapsulating extracted logos
    # @author pkubiak
    class SimpleContainer
    
      # Return Uniform Resource Identifier of contained object (maybe url or data uri)
      # @return [URI] uri identifying location of contained object
      def uri()
        raise NotImplementedError
      end
      
      # Return location from where the object data was originaly downloaded
      # @return [URI] oringinal location of object file (or file containing this object)
      def original_url()
        raise NotImplementedError
      end
      
      # Return StringIO containing object byte data
      # @return [StringIO] object data
      def data()
        raise NotImplementedError
      end
      
      # Return criterions weights extracted for this object
      # @return [Hash<Symbol, Float>] hash with weights assiged to criterions
      def criterions()
        raise NotImplementedError
      end 
    end
  end
end