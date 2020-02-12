# frozen_string_literal: true

#
# Defines the Ruby specification.
#

require_relative '../spec_helper'

describe command('ruby --version') do
  its(:stdout) { should match(/^ruby 2\..+/) }
end
