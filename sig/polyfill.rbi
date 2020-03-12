class Pathname
  def self.glob: (String | Pathname | Array<Pathname> | Array<String>, ?Integer) -> Array<Pathname>
  def glob: (String | Pathname | Array<Pathname> | Array<String>, ?Integer) -> Array<Pathname>
  def +: (Pathname | String) -> Pathname
  alias / +
  def exist?: -> bool
  def file?: -> bool
  def relative_path_from: (Pathname) -> Pathname
  def open: <'a> (?String) { (IO) -> 'a } -> 'a
  def join: (String | Pathname) -> self
  def realpath: -> self
  def directory?: -> bool
  def relative?: -> bool
  def cleanpath: -> self
  def read: -> String
  def mkpath: -> void
  def write: (String, ?perm: Integer) -> void
  def sub_ext: (String) -> self
  def expand_path: (*String) -> self
  def parent: -> self
  def basename: -> self
  def fnmatch?: (String, Integer) -> bool
  def delete: -> void
  def to_path: -> String
end

extension Object (Polyfill)
  def instance_of?: (any) -> bool
  def then: <'a> () { (self) -> 'a } -> 'a
end

class UnboundMethod
  def source_location: -> [String, Integer]
end

extension Module (Polyfill)
  def private: (*any) -> void
  def name: -> String
  def instance_method: (Symbol) -> UnboundMethod
  def define_method: (Symbol) { () -> any } -> Symbol
  def method_defined?: (Symbol, ?bool) -> bool
end

extension String (Polyfill)
  def strip: -> String
  def strip!: -> String
  def casecmp?: (String) -> bool?
  def delete: (*String) -> String
  def delete_prefix: (String) -> String
  def lines: (?chomp: bool)-> Array<String>
  def to_sym: -> Symbol
end

extension Symbol (Polyfill)
  def to_sym: -> Symbol
end

class Time
  def self.now: -> Time
  def utc: -> self
  def iso8601: -> String
  def strftime: (String) -> String
  def -: (Integer) -> self
       | (Time) -> Float
  def +: (Integer) -> self
end

class Exception
  def backtrace: -> Array<String>?
  def message: -> String
end

extension Array (Polyfill)
  def sort!: -> self
  def join: () -> String
          | (any) -> String
  def +: <'x> (Array<'x>) -> Array<'a | 'x>
       | (self) -> self
  def filter: { ('a) -> bool } -> self
end

extension File (Polyfill)
  def self.basename: (String | Pathname, ?String) -> String
  def self.write: (String, String, ?perm: Integer) -> Integer
end

class Digest
end

class Digest::SHA1
  def self.hexdigest: (String) -> String
  def file: (String) -> instance
end

class FileUtils
  def self.rm: (Array<String>) -> void
  def self.install: (String, String, ?any) -> void
  def self.copy_entry: (any, any) -> void
  def self.remove_entry: (String|Pathname, ?bool) -> void
  def self.rm_rf: (String | Pathname | Array<String> | Array<Pathname>) -> void
end

class Dir
  def self.mktmpdir: <'a> { (String) -> 'a } -> 'a
                   | () -> String
end

class URI
  def self.parse: (String) -> URI
  def self.join: (*String) -> URI
  def path: -> String
  def scheme: -> String
  def host: -> String
  def userinfo=: (String) -> String
end

class Net::HTTP
  def self.get_response: <'a> (URI) { (any) -> 'a } -> 'a
end

class Open3
  def self.capture2e: (*any, ?chdir: any) -> [String, Process::Status]
  def self.capture3: (*any) -> [String, String, Process::Status]
end

module SecureRandom
  def self.alphanumeric: (?Integer?) -> String
  def self.base64: (?Integer?) -> String
  def self.hex: (?Integer?) -> String
  def self.random_bytes: (?Integer?) -> String
  def self.random_number: (?Integer) -> (Integer | Float)
  def self.urlsafe_base64: (?Integer?, ?bool) -> String
  def self.uuid: -> String
end

class OpenSSL::Cipher
  def self.ciphers: -> Array<String>
  def initialize: (String) -> any
  def block_size: -> Integer
  def decrypt: (?String, ?String?) -> self
  def encrypt: () -> self
             | (String, ?String?) -> self
  def final: -> String
  def iv=: (String) -> String
  def iv_len: -> Integer
  def key=: (String) -> String
  def key_len: -> Integer
  def key_len=: (Integer) -> Integer
  def name: -> String
  def padding=: (0|1) -> (0|1)
  def pkcs5_keyivgen: (String, ?String?, ?Integer, ?String) -> void
  def random_iv: -> String
  def random_key: -> String
  def reset: -> self
  def update: (String) -> String
end

class Tempfile
  def self.open: <'a> { (File) -> 'a } -> 'a
end

class OpenSSL::Cipher::CipherError
end

class Net::OpenTimeout
end

class Errno::ECONNRESET
end

module Retryable
  def self.retryable: <'a> (*any) { () -> 'a } -> 'a
end

extension Hash (Polyfill)
  def deep_merge: (Hash<any, any>) -> Hash<any, any>
  def fetch: ('key, ?'value) -> 'value
  def merge!: (*Hash<any, any>) -> Hash<any, any>
  def compact: -> self
  def dig: (*'key) -> 'value?
  def []=: (any, any) -> any
  def slice: (*'key) -> self
end

class Psych::SyntaxError
  attr_reader line: Integer
  attr_reader column: Integer
end

class YAML
  def self.load_file: (String, fallback: any) -> any
  def self.safe_load: (String, symbolize_names: bool) -> any
end
