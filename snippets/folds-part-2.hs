import Data.List
import Data.Tuple

data Context = Context Int

tagItems :: ([a], Context) -> ([(a, Int)], Context)
tagItems (ys, ctx) = swap $ mapAccumL f ctx ys
  where f (Context x) y = (Context (x + 1), (y, x))

main :: IO ()
main = do
  let ctx = Context 1000
      (items, ctx') = tagItems (["one", "two", "three"], ctx)
  putStrLn $ show items
-- Yields: [("one",1000),("two",1001),("three",1002)]

