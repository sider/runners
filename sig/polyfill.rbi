class Pathname
  def self.glob: (Pathname, ?Integer) -> Array<Pathname>
  def +: (Pathname) -> Pathname
       | (String) -> Pathname
  alias / +
  def exist?: -> bool
  def file?: -> bool
  def relative_path_from: (Pathname) -> Pathname
  def open: <'a> (?String) { (IO) -> 'a } -> 'a
  def join: (String) -> self
  def realpath: -> self
  def directory?: -> bool
  def relative?: -> bool
  def cleanpath: -> self
  def read: -> String
  def mkpath: -> void
  def write: (String) -> void
  def sub_ext: (String) -> self
  def expand_path: (*String) -> self
  def delete: -> void
  def parent: -> self
end

extension Object (Pathname)
  def Pathname: (String) -> Pathname
end

extension Object (Polyfill)
  def instance_of?: (any) -> bool
  def Array: (any) -> Array<any>
end

extension Module (Polyfill)
  def private: (*any) -> void
  def name: -> String
end

extension String (Polyfill)
  def strip: -> String
  def strip!: -> String
  def match: (Regexp) -> MatchData?
           | <'x> (Regexp) { (MatchData) -> 'x } -> 'x
  def each_line: { (String) -> any } -> String

  # ActiveSupport
  def pluralize: () -> String
               | (Integer) -> String
end

extension Float (Polyfill)
  def to_i: -> Integer
end

extension Kernel (Polyfill)
  def exit: (Integer) -> void
  def system: (String) -> any
  def load: (String) -> bool
end

extension NilClass (Polyfill)
  def to_i: -> Integer
end

class Time
  def self.now: -> Time
  def utc: -> self
  def iso8601: -> String
  def -: (Integer) -> self
       | (Time) -> Integer
  def +: (Integer) -> self
end

class Exception
end

extension Array (Polyfill)
  def sort!: -> self
  def join: () -> String
          | (any) -> String
  def +: <'x> (Array<'x>) -> Array<'a | 'x>
       | (self) -> self
end

extension File (Polyfill)
  def self.basename: (String | Pathname) -> String
  def self.write: (String | Pathname, String) -> void
end

class Digest
end

class Digest::SHA1
  def file: (String) -> instance
  def self.hexdigest: (String) -> String
end

class FileUtils
  def self.rm: (Array<String>) -> void
  def self.rm_r: (Array<String>, secure: bool) -> void
  def self.install: (String, String, ?any) -> void
  def self.copy_entry: (any, any) -> void
  def self.cp: (String | Pathname, String | Pathname) -> void
end

class Dir
  def self.home: -> String
  def self.mktmpdir: <'a> { (String) -> 'a } -> 'a
  def self.glob: (String | Pathname) -> Array<String>
end

class URI
  def self.parse: (String) -> URI
  def path: -> String
  def scheme: -> String
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
  def fetch: ('key) -> 'value
  def merge!: (*Hash<'key, 'value>) -> Hash<'key, 'value>
  def dig: (*any) -> any
  def named_captures: -> Hash<String, String | nil>

  # ActiveSupport
  def deep_symbolize_keys: -> Hash<Symbol, any>
end

class Bundler::LockfileParser
  def initialize: (String) -> any
  def specs: -> any
end

class Psych::SyntaxError
end

class YAML
  def self.load_file: (String, fallback: any) -> any
  def self.safe_load: (String, symbolize_names: bool) -> any
end
