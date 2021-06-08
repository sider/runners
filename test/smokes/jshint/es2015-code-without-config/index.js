// jshint regexpu:true

class Foo {
  constructor(name) {
    this.name = name;
  }

  hello() {
    console.log(`Hello, ${this.name}.`);
    return /a/;
  }
}

(function () {
  const foo = new Foo('John');
  foo.hello();
  console.log([1,2,3,4,5].map(value => value + 1));
})();
