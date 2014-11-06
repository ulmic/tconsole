# -*- coding: utf-8 -*-
require 'minitest'
module TConsole
  class MiniTestHandler
    def self.setup(config)
      @results = TConsole::TestResult.new

      @results.suite_counts = config.cached_suite_counts
      @results.elements = config.cached_elements
    end

    def self.match_and_run(match_patterns, config, reporter)
      suites = Minitest::Runnable.runnables

      suites.each do |suite|
        suite_id = @results.elements[suite.to_s]
        if suite.methods_matching(/^test/).any?
          #reporter.info("#{suite} #{suite_id}")
        end

        suite.methods_matching(/^test/).map do |method|
          id = @results.add_element(suite, method)

          unless match_patterns.nil?
            match = match_patterns.find do |pattern|
              pattern == suite.to_s ||
                pattern == "#{suite.to_s}##{method.to_s}" ||
                pattern == suite_id.to_s ||
                pattern == id
            end
          end

          if match_patterns.nil? || match_patterns.empty? || !match.nil?
            # TODO переделать на Minitest::Runnable.run_one_method(klass, method,
            # reporter), совать reporter
            res = Minitest.run_one_method(suite, method)

            # TODO надо вместо этого говна прикрутить minitest-reporters
            test_res = if res.error?
              reporter.error("#{suite}##{method} #{id} ERROR")
              # TODO
              reporter.info(res.failure.exception.message)
              reporter.info(Minitest.filter_backtrace(res.failure.exception.backtrace))
            elsif res.skipped?
              reporter.warn("#{suite}##{method} #{id} SKIP")
            elsif res.failure
              @results.failures << id
              reporter.error("#{suite}##{method} #{id} FAIL")
              # TODO
              reporter.info(res.failure.exception.message)
              reporter.info(Minitest.filter_backtrace(res.failure.exception.backtrace))
            else
              reporter.exclaim("#{suite}##{method} #{id} PASS")
            end

          end
        end

        if suite.methods_matching(/^test/).any?
          #reporter.info("")
        end
      end

      @results
    end

    # Preloads our element cache for autocompletion. Assumes tests are already loaded
    def self.preload_elements
      patch_minitest
      results = TConsole::TestResult.new
      suites = Minitest::Runnable.runnables
      suites.each do |suite|
        suite.methods_matching(/^test/).map do |method|
          id = results.add_element(suite, method)
        end
      end

      results
    end

    # We're basically breaking Minitest autorun here, since we want to manually run our
    # tests and Rails relies on autorun
    # A big reason for the need for this is that we're trying to work in the Rake environment
    # rather than rebuilding all of the code in Rake just to get test prep happening
    # correctly.
    def self.patch_minitest
      Minitest.class_eval do
        class << self
          alias_method :old_run, :run
          def run(args = [])
          end
        end
      end
    end
  end
end

# Make sure that output is only colored when it should be
Term::ANSIColor::coloring = STDOUT.isatty
