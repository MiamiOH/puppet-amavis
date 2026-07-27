require 'spec_helper'

describe 'amavis', type: :class do
  let(:facts) { { operatingsystem: 'Debian', operatingsystemrelease: '7.1' } }

  it { is_expected.to contain_package('amavisd-new') }
  it { is_expected.to contain_service('amavis') }
  it { is_expected.to contain_exec('amavis') }
  context 'with spamassassin => true' do
    let(:params) { { spamassassin: true } }

    it { is_expected.to contain_package('spamassassin') }
  end
  context 'with spamassassin => false' do
    let(:params) { { spamassassin: false } }

    it { is_expected.not_to contain_package('spamassassin') }
  end
end
