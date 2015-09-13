# encoding: utf-8

require_relative "brokers/broker"

module ROM::Kafka

  # Value object describing a collection of brokers (host:port)
  #
  # Knows how to extract brokers from address lines and options
  #
  # @example
  #   brokers = Brokers.new(
  #     "localhost:9092",
  #     "127.0.0.1",
  #     hosts: ["127.0.0.2:9094"],
  #     port: 9093,
  #     unknown_key: :foo # will be ignored by the initializer
  #   )
  #
  #   brokers.to_a
  #   # => ["localhost:9092", "127.0.0.2:9093", "127.0.0.3:9094"]
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  class Brokers

    include Equalizer.new(:to_a)

    # Initializes an immutable collection from address lines and/or options
    #
    # The initializer is options-tolerant: it just ignores unknown options.
    #
    # @param [#to_s, Array<#to_s>] lines
    # @param [Hash] options
    #
    # @option options [#to_s, Array<#to_s>] :hosts
    # @option options [#to_i] :port
    #
    def initialize(*lines, **options)
      port  = options[:port]
      hosts = (lines + Array[options[:hosts]]).compact.flatten

      @brokers = hosts.map { |host| Broker.new(host: host, port: port) }
      @brokers = [Broker.new] unless @brokers.any?

      IceNine.deep_freeze(self)
    end

    # Returns array of string representations of brokers
    #
    # @return [Array<String>]
    #
    def to_a
      @brokers.map(&:to_s)
    end

  end # class Brokers

end # module ROM::Kafka