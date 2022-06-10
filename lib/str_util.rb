module StrUtil
  def self::is_valid_float? (str)
    !!Float(str) rescue false
  end
end
