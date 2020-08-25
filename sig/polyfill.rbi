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
  def rename: (Pathname) -> 0
  def parent: -> Pathname
  def rmdir: -> 0
  def chmod: (Integer) -> Integer
end

extension Object (Polyfill)
  def instance_of?: (any) -> bool
  def then: <'a> () { (self) -> 'a } -> 'a
  def public_send: (String | Symbol, *any) -> any
end

class UnboundMethod
  def source_location: -> [String, Integer]
end

extension Module (Polyfill)
  def private: (*any) -> void
  def private_class_method: (*Symbol) -> void
  def name: -> String
  def instance_method: (Symbol) -> UnboundMethod
  def define_method: (Symbol) { () -> any } -> Symbol
  def method_defined?: (Symbol, ?bool) -> bool
  def private_constant: (*Symbol) -> self
end

extension String (Polyfill)
  def strip: -> String
  def strip!: -> String
  def casecmp?: (String) -> bool?
  def delete: (*String) -> String
  def delete_prefix: (String) -> String
  def lines: (?chomp: bool)-> Array<String>
  def to_sym: -> Symbol
  def each_line: (?String, ?chomp: bool) { (String) -> void } -> self
  def include?: (String) -> bool
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
  def filter_map: <'x> { ('a) -> 'x } -> Array<'x>
end

extension File (Polyfill)
  def self.basename: (String | Pathname, ?String) -> String
  def self.write: (String, String, ?perm: Integer) -> Integer
  def self.file?: (String) -> bool
  def self.expand_path: (String, ?String) -> String
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
  def self.chdir: <'a> (String) { (String) -> 'a } -> 'a
  def self.home: () -> String
end

class URI
  def self.parse: (String) -> URI
  def self.join: (*String) -> URI
  def path: -> String
  def scheme: -> String
  def host: -> String
  def hostname: -> String
  def port: -> Integer
  def userinfo=: (String) -> String
end

class Net::HTTP
  def self.start: <'a> (String, Integer, Hash<Symbol, any>) { (HTTP) -> 'a } -> 'a
  def request_get: (URI) { (Net::HTTPResponse) -> void } -> void
end

class Net::HTTPResponse
  include Net::HTTPHeader

  attr_reader code: String
  attr_reader message: String

  def read_body: (::IO) -> void
end

module Net::HTTPHeader
  def []: (String) -> String
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

class Net::OpenTimeout
end

class Errno::ECONNRESET
end

module Retryable
  def self.retryable: <'a> (*any) { () -> 'a } -> 'a
end

extension Hash (Polyfill)
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
  def self.safe_load: (String, ?symbolize_names: bool) -> any
end

# HACK: To avoid receiving the error message `Unknown alias: untyped`,
#       define `untyped` alias here. Such a hack is required until the migration to Steep 0.14 or later completes.
type untyped = any

extension Set<'a> (Polyfill)
  def filter: { ('a) -> any } -> Set<'a>
end

extension Numeric (Polyfill)
  def div: (Numeric) -> Integer
  def positive?: () -> bool
end

extension Float (Polyfill)
  def to_i: () -> Integer
end

extension Integer (Polyfill)
  def **: (Float) -> Float
        | super
end
