require "spec_helper"

describe JiraGateway do

  User = Struct.new(:url, :username, :password)
  Response = Struct.new(:body, :success?)

  let(:http_mock) { spy('http') }
  subject do
    JiraGateway.new(http_mock,
                    User.new('http://jira.local', 'user', 'password'))
  end

  it 'should return symbolized hash for JSON result' do
    expect(http_mock).to receive(:basic_auth).with('user', 'password')
    expect(http_mock).to receive(:get)
      .with('http://jira.local/rest/api/2/issue/PRO-98')
      .and_return(Response.new('{"key":"PRO-98"}', true))
    expect(subject.data_for_issue('PRO-98')).to eq({key: 'PRO-98'})
  end

  it 'should return empty hash when response fails' do
    expect(http_mock).to receive(:get)
      .and_return(Response.new('{"key":"NOT_USED"}', false))
    expect(subject.data_for_issue('some key')).to eq({})
  end
end
