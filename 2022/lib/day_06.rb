module TuningTrouble
  class HandheldDevice
    def lock_on_to signal
      @signal = signal
      self
    end
    
    attr_reader :signal

    def start_of_packet_marker_position
      cons_uniq_chars_pos 4
    end
    
    def start_of_message_marker_position
      cons_uniq_chars_pos 14
    end
    
    private
    
    def cons_uniq_chars n
      signal.each_char.each_cons(n).find { |chars| chars == chars.uniq }.join
    end
    
    def cons_uniq_chars_pos n
      signal.index(cons_uniq_chars(n)) + n
    end
  end
end