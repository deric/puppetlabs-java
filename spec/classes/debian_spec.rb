require 'spec_helper'

describe 'java', :type => :class do

  context 'select Oracle JRE for Debian Wheezy' do
    let(:facts) { {
      :osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistid => 'Debian',
      :lsbdistcodename => 'wheezy', :operatingsystemrelease => '7.1',
      :architecture => 'amd64',
    } }

    let(:params) { {
      'package'      => 'oracle-java8-installer',
      'source'       => 'webupd8team',
      'distribution' => 'jre'
    } }
    it { should contain_class('apt') }
    it { should contain_package('java').with_name('oracle-java8-installer') }
    it { should contain_package('oracle-java8-set-default').with_ensure('present') }
    it { should contain_package('oracle-java8-jre').with_ensure('present') }
    it { should contain_apt__source('webupd8team-java').with_location('http://ppa.launchpad.net/webupd8team/java/ubuntu') }
  end

  context 'select Oracle JDK for Debian Jessie' do
    let(:facts) { {
      :osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistid => 'Debian',
      :lsbdistcodename => 'jessie', :operatingsystemrelease => '8.1',
      :architecture => 'amd64',
    } }

    let(:params) { {
      'package' => 'oracle-java9-installer',
      'source'  => 'webupd8team',
      'release' => 'java9'
    } }
    it { should contain_class('apt') }
    it { should contain_package('java').with_name('oracle-java9-installer') }
    it { should contain_package('oracle-java9-set-default').with_ensure('present') }
    it { should contain_package('oracle-java9-jdk').with_ensure('present') }
    it { should contain_apt__source('webupd8team-java').with_location('http://ppa.launchpad.net/webupd8team/java/ubuntu') }
  end

end