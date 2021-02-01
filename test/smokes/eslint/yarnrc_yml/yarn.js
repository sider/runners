if (process.argv.includes("-v")) {
  console.log("Dummy Yarn 2.0.0")
} else {
  throw new Error("Dummy Yarn failed!")
}
