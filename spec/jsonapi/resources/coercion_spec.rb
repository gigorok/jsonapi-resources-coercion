require "spec_helper"

describe JSONAPI::Resources::Coercion do
  it 'has a version number' do
    expect(JSONAPI::Resources::Coercion::VERSION).to eq('0.1.1')
  end

  context 'with filters' do
    let(:resource) do
      BookResource.new(book, context)
    end

    let(:context) do
      {}
    end

    let(:book) do
      double(:book)
    end

    subject do
      BookResource.verify_filter(filter, raw_filter_value, context)
    end

    shared_examples :should_return do
      it 'should return' do
        expect(subject).to eq([filter, filter_value])
      end
    end

    shared_examples :should_raise_the_exception do
      it 'should raise the exception' do
        expect { subject }.to raise_error(JSONAPI::Exceptions::InvalidFilterValue)
      end
    end

    context 'filter by title' do
      let(:filter) do
        :title
      end

      let(:raw_filter_value) do
        'Lord of the rings'
      end

      let(:filter_value) do
        ['Lord of the rings'] # as is
      end

      it_behaves_like :should_return
    end

    context 'filter by qty' do
      let(:filter) do
        :qty
      end

      let(:raw_filter_value) do
        '12'
      end

      let(:filter_value) do
        [12]
      end

      it_behaves_like :should_return

      it 'filter_value should be an fixnum' do
        expect(subject[1][0]).to be_an_instance_of(Fixnum)
      end

      it_behaves_like :should_raise_the_exception do
        let(:raw_filter_value) do
          '12.34'
        end
      end

      it_behaves_like :should_raise_the_exception do
        let(:raw_filter_value) do
          'sdf'
        end
      end

    end

    context 'filter by available' do
      let(:filter) do
        :available
      end

      {
          'true' => true,
          't' => true,
          'yes' => true,
          'y' => true,
          '1' => true,
          'false' => false,
          'f' => false,
          'no' => false,
          'n' => false,
          '0' => false
      }.each do |k, v|
        let(:raw_filter_value) do
          k
        end

        let(:filter_value) do
          [v]
        end

        it_behaves_like :should_return
      end

      it_behaves_like :should_raise_the_exception do
        let(:raw_filter_value) do
          'boom'
        end
      end

    end

    context 'filter by weight' do
      let(:filter) do
        :weight
      end

      let(:raw_filter_value) do
        '12.34'
      end

      let(:filter_value) do
        [12.34]
      end

      it_behaves_like :should_return

      it 'filter_value should be a float' do
        expect(subject[1][0]).to be_an_instance_of(Float)
      end

      it_behaves_like :should_raise_the_exception do
        let(:raw_filter_value) do
          'boom'
        end
      end
    end

    context 'filter by price' do
      let(:filter) do
        :price
      end

      let(:raw_filter_value) do
        '12.34'
      end

      let(:filter_value) do
        [12.34]
      end

      it_behaves_like :should_return

      it 'filter_value should be a big_decimal' do
        expect(subject[1][0]).to be_an_instance_of(BigDecimal)
      end

      it_behaves_like :should_raise_the_exception do
        let(:raw_filter_value) do
          'boom'
        end
      end
    end

    context 'filter by published_at' do
      let(:filter) do
        :published_at
      end

      let(:raw_filter_value) do
        '2016-12-15 12:55:32'
      end

      let(:filter_value) do
        [Time.parse(raw_filter_value)]
      end

      it_behaves_like :should_return

      it 'filter_value should be a date_time' do
        expect(subject[1][0]).to be_an_instance_of(Time)
      end

      it_behaves_like :should_raise_the_exception do
        let(:raw_filter_value) do
          'boom'
        end
      end

      it_behaves_like :should_raise_the_exception do
        let(:raw_filter_value) do
          '1234'
        end
      end
    end

  end
end
