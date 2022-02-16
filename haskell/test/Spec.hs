import Test.Hspec

import Hello

main :: IO ()
main = hspec $ do
  it "should be \"hello world!\"" $ helloString `shouldBe` "hello world!"
