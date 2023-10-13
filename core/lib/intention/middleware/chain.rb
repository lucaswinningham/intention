# frozen_string_literal: true

require_relative 'entry'

module Intention
  module Middleware
    class Chain
      IDENTITY = proc { |x| x }.freeze

      def initialize(&block)
        block.call(self) if block_given?
      end

      def remove(klass)
        entries.delete_if { |entry| entry.klass == klass }
      end

      def add(klass, *args, **kwargs, &block)
        remove(klass) if exists?(klass)

        entries << Entry.new(klass, *args, **kwargs, &block)
      end

      def prepend(klass, *args, **kwargs, &block)
        remove(klass) if exists?(klass)

        entries.insert(0, Entry.new(klass, *args, **kwargs, &block))
      end

      def insert_before(old_klass, klass, *args, **kwargs, &block)
        i = entries.index { |entry| entry.klass == klass }
        new_entry = i.nil? ? Entry.new(klass, *args, **kwargs, &block) : entries.delete_at(i)
        i = entries.index { |entry| entry.klass == old_klass } || 0
        entries.insert(i, new_entry)
      end

      def insert_after(old_klass, klass, *args, **kwargs, &block)
        i = entries.index { |entry| entry.klass == klass }
        new_entry = i.nil? ? Entry.new(klass, *args, **kwargs, &block) : entries.delete_at(i)
        i = entries.index { |entry| entry.klass == old_klass } || entries.count - 1
        entries.insert(i + 1, new_entry)
      end

      def exists?(klass)
        entries.any? { |entry| entry.klass == klass }
      end

      def call(payload)
        chain = materialize.dup.reverse.reduce(IDENTITY) do |composition, entry|
          entry.call(composition)
        end

        chain.call(payload)
      end

      private

      def entries
        @entries ||= []
      end

      def materialize
        entries.map do |entry|
          proc { |succ| entry.klass.new(succ, *entry.args, **entry.kwargs, &entry.block) }
        end
      end
    end
  end
end
