require 'spec_helper'
require 'parser/current'

RSpec.describe 'Unassertive' do
  def rewrite(code)
    buffer        = Parser::Source::Buffer.new('(example)')
    buffer.source = code.strip
    parser        = Parser::CurrentRuby.new
    ast           = parser.parse(buffer)
    rewriter      = Unassertive.new
    rewriter.rewrite(buffer, ast)
  end

  describe '#assert' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert bar))).to eq(%{expect(bar).to be_truthy})
      expect(rewrite(%(assert !bar))).to eq(%{expect(bar).to be_falsey})
    end
  end

  describe '#refute' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_not bar))).to eq(%{expect(bar).to be_falsey})
      expect(rewrite(%(refute bar))).to eq(%{expect(bar).to be_falsey})

      expect(rewrite(%(assert_not !bar))).to eq(%{expect(bar).to be_truthy})
      expect(rewrite(%(refute !bar))).to eq(%{expect(bar).to be_truthy})
    end
  end

  describe '#assert_block'

  describe '#assert_nil' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_nil foo))).to eq(%{expect(foo).to be_nil})
      expect(rewrite(%(assert_nil @foo))).to eq(%{expect(@foo).to be_nil})

      expect(rewrite(%(assert_not_nil bar))).to eq(%{expect(bar).not_to be_nil})
      expect(rewrite(%(refute_nil bar))).to eq(%{expect(bar).not_to be_nil})
    end
  end

  describe '#assert_empty' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_empty foo))).to eq(%{expect(foo).to be_empty})
      expect(rewrite(%(assert_not_empty foo))).to eq(%{expect(foo).not_to be_empty})
      expect(rewrite(%(refute_empty foo))).to eq(%{expect(foo).not_to be_empty})
    end
  end

  describe '#assert_equal' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_equal foo, bar))).to eq(%{expect(bar).to eq(foo)})
      expect(rewrite(%(assert_not_equal foo, bar))).to eq(%{expect(bar).not_to eq(foo)})
      expect(rewrite(%(refute_equal foo, bar))).to eq(%{expect(bar).not_to eq(foo)})
    end
  end

  describe '#assert_in_delta'
  describe '#assert_in_epsilon'

  describe '#assert_includes' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_includes collection, item)))
        .to eq(%{expect(collection).to include(item)})
      expect(rewrite(%(assert_not_includes collection, item)))
        .to eq(%{expect(collection).not_to include(item)})
      expect(rewrite(%(refute_includes collection, item)))
        .to eq(%{expect(collection).not_to include(item)})
    end
  end

  describe '#assert_instance_of' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_instance_of Clazz, bar)))
        .to eq(%{expect(bar).to be_instance_of(Clazz)})
      expect(rewrite(%(assert_not_instance_of Clazz, bar)))
        .to eq(%{expect(bar).not_to be_instance_of(Clazz)})
      expect(rewrite(%(refute_instance_of Clazz, bar)))
        .to eq(%{expect(bar).not_to be_instance_of(Clazz)})
    end
  end

  describe '#assert_kind_of' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_kind_of Clazz, bar)))
        .to eq(%{expect(bar).to be_kind_of(Clazz)})
      expect(rewrite(%(assert_not_kind_of Clazz, bar)))
        .to eq(%{expect(bar).not_to be_kind_of(Clazz)})
      expect(rewrite(%(refute_kind_of Clazz, bar)))
        .to eq(%{expect(bar).not_to be_kind_of(Clazz)})
    end
  end

  describe '#assert_match' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_match /foo/, bar))).to eq(%{expect(bar).to match(/foo/)})
      expect(rewrite(%(assert_not_match /foo/, bar))).to eq(%{expect(bar).not_to match(/foo/)})
      expect(rewrite(%(refute_match /foo/, bar))).to eq(%{expect(bar).not_to match(/foo/)})
    end
  end

  describe '#assert_operator'
  describe '#assert_output'
  describe '#assert_predicate'
  describe '#assert_raises'

  describe '#assert_respond_to' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_respond_to obj, :meth))).to eq(%{expect(obj).to respond_to(:meth)})
      expect(rewrite(%(assert_not_respond_to obj, :meth))).to eq(%{expect(obj).not_to respond_to(:meth)})
      expect(rewrite(%(refute_respond_to obj, :meth))).to eq(%{expect(obj).not_to respond_to(:meth)})
    end
  end

  describe '#assert_same' do
    it 'rewrites assertions' do
      expect(rewrite(%(assert_same foo, bar))).to eq(%{expect(bar).to be(foo)})
      expect(rewrite(%(assert_not_same foo, bar))).to eq(%{expect(bar).not_to be(foo)})
      expect(rewrite(%(refute_same foo, bar))).to eq(%{expect(bar).not_to be(foo)})
    end
  end

  describe '#assert_send'
  describe '#assert_silent'
  describe '#assert_throws'
end
