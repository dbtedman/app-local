# frozen_string_literal: true

#
# Defines the Node specification.
#

require_relative '../spec_helper'

describe command('source /home/vagrant/.bashrc && node --version') do
  its(:stdout) { should match(/^v7\..+/) }
end

describe command('source /home/vagrant/.bashrc && npm --version') do
  its(:stdout) { should match(/^4\..+/) }
end
