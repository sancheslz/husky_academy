# frozen_string_literal: true

class PixKey
  attr_reader :token, :type

  @@key_pattern = {
    phone: /^\+[1-9][0-9]\d{1,14}$/,
    cpf: /^[0-9]{11}$/,
    cnpj: /^[0-9]{14}$/,
    email: /^[a-z0-9.!#$&'*+\/=?^_`{}~-]+@[a-z0-9](?:[\.a-z0-9])*$/,
    evp: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  }

  def initialize(token)
    @token = token.instance_of?(String) ? token.strip.freeze : ''
    @type = validate
  end

  alias_method :key, :token
  alias_method :to_s, :token
  alias_method :value, :token

  def valid?
    not @type.nil?
  end

  def invalid?
    @type.nil?
  end

  def _check_type
    __callee__.to_s.chop == @type
  end

  @@key_pattern.each_key { |key| alias_method "#{key}?", :_check_type }

  def ==(other)
    other.instance_of?(self.class) && @token == other.to_s
  end

  private
  def validate
    # check = @@key_pattern.map { |k, v| k if @token.match(v) }.compact
    check = @@key_pattern.map { |k, v| k if v =~ @token }.compact
    return if check.empty?

    check.first.to_s.freeze
  end
end
