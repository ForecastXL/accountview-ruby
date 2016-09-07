require 'spec_helper'

describe Accountview do
  before(:all) do
    @client = Accountview::Client.new({
      consumer_key: '',
      consumer_secret: '',
      refresh_token: '',
      token: ''
    })

    @client.refresh_token!
    @client.set_current_company
  end

  describe 'api_methods' do
    it 'should get creditors with book_dates' do
      book_dates = []

      book_dates << Date.new(2014, 1, 1)
      book_dates << Date.new(2015, 10, 1)

      @creditors = []
      book_dates.each do |book_date|
        @creditors << @client.creditors(book_date.strftime('%Y-%m-%d'))['CONTACT']
      end

      @creditors
    end

    it 'should get debtors with book_dates' do
      book_dates = []

      book_dates << Date.new(2014, 1, 1)
      book_dates << Date.new(2015, 10, 1)

      @creditors = []
      book_dates.each do |book_date|
        @creditors << @client.debtors(book_date.strftime('%Y-%m-%d'))['CONTACT']
      end

      @creditors
    end

    it 'should get creditors' do
      p 'Getting creditors'
      @creditors = @client.creditors

      p @creditors
    end

    it 'should get debtors' do

      p 'Getting departments'
      @debtors = @client.debtors

      p @debtors
    end
  end
end
