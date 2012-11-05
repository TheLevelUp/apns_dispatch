require 'spec_helper'

describe ApnsDispatch::ApnsConnectionPool do
  before do
    @options = { production: true }
  end

  context 'when a certificate is given' do
    before do
      @certificate = 'test-certificate'
      @connection = ApnsDispatch::ApnsConnectionPool.connection(@certificate, @options)
    end

    context 'when called for the first time' do
      it 'returns a new ApnsConnection with the correct values' do
        @connection.certificate.should == @certificate
        @connection.options.should == @options
      end
    end

    context 'when called after the first time' do
      it 'returns the same connection' do
        ApnsDispatch::ApnsConnectionPool.connection(@certificate, @options).should == @connection
      end
    end
  end

  context 'when a nil certificate is given' do
    it 'returns a null connection' do
      result = ApnsDispatch::ApnsConnectionPool.connection(nil)
      result.should be_kind_of(ApnsDispatch::NullApnsConnection)
    end
  end
end
