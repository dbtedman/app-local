# frozen_string_literal: true

#
# Defines the MySQL specification.
#

require_relative '../spec_helper'

describe port(3306) do
  it { should be_listening }
end
