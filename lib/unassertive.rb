require 'parser'

class Unassertive < Parser::Rewriter
  def on_send(node)
    receiver, method, *args = *node

    case method
    when :assert
      replace_assert(node)
    when :assert_not, :refute
      replace_assert(node, negate: true)
    when :assert_nil
      replace_assert_1arg(node, 'be_nil')
    when :assert_not_nil, :refute_nil
      replace_assert_1arg(node, 'be_nil', negate: true)
    when :assert_empty
      replace_assert_1arg(node, 'be_empty')
    when :assert_not_empty, :refute_empty
      replace_assert_1arg(node, 'be_empty', negate: true)
    when :assert_equal
      replace_assert_2args(node, 'eq')
    when :assert_not_equal, :refute_equal
      replace_assert_2args(node, 'eq', negate: true)
    when :assert_includes
      replace_assert_2args(node, 'include', reverse_args: true)
    when :assert_not_includes, :refute_includes
      replace_assert_2args(node, 'include', negate: true, reverse_args: true)
    when :assert_instance_of
      replace_assert_2args(node, 'be_instance_of')
    when :assert_not_instance_of, :refute_instance_of
      replace_assert_2args(node, 'be_instance_of', negate: true)
    when :assert_kind_of
      replace_assert_2args(node, 'be_kind_of')
    when :assert_not_kind_of, :refute_kind_of
      replace_assert_2args(node, 'be_kind_of', negate: true)
    when :assert_match
      replace_assert_2args(node, 'match')
    when :assert_not_match, :refute_match
      replace_assert_2args(node, 'match', negate: true)
    when :assert_respond_to
      replace_assert_2args(node, 'respond_to', reverse_args: true)
    when :assert_not_respond_to, :refute_respond_to
      replace_assert_2args(node, 'respond_to', negate: true, reverse_args: true)
    when :assert_same
      replace_assert_2args(node, 'be')
    when :assert_not_same, :refute_same
      replace_assert_2args(node, 'be', negate: true)
    end
  end

  private

  def replace_assert(node, negate: false)
    actual_source = node.children[2].loc.expression.source

    if actual_source.start_with?('!')
      actual_source = actual_source[1, actual_source.length]
      negate = negate ^ true
    end

    replace(node.loc.expression, "expect(#{actual_source}).to be_#{negate ? 'falsey' : 'truthy'}")
  end

  def replace_assert_1arg(node, matcher, negate: false)
    actual_source = node.children[2].loc.expression.source

    replace(node.loc.expression, "expect(#{actual_source}).#{negate ? 'not_to' : 'to'} #{matcher}")
  end

  def replace_assert_2args(node, matcher, negate: false, reverse_args: false)
    sources = node.children[2..3].map { |n| n.loc.expression.source }
    expected_source, actual_source = *(reverse_args ? sources.reverse : sources)

    replace(node.loc.expression, "expect(#{actual_source}).#{negate ? 'not_to' : 'to'} #{matcher}(#{expected_source})")
  end
end
