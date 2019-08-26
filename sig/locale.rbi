# https://github.com/ruby-gettext/locale

module Locale
end

class Locale::Tag
  def country: -> String
  def language: -> String
  def self.parse: (String) -> Locale::Tag
end
