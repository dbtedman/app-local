# frozen_string_literal: true

#
# Defines the Apache PHP specification.
#

require_relative '../spec_helper'

describe port(443) do
  it { should be_listening }
end

describe service('httpd') do
  it { should be_enabled }
  it { should be_running }
end
