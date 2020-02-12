# frozen_string_literal: true

#
# Defines the Oracle Tools specification.
#

require_relative '../spec_helper'

describe 'OracleXE Database' do
  describe port(1521) do
    it { should be_listening }
  end
end
