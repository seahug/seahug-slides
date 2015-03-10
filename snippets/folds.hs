data Context = Context Int

tagItems :: ([a], Context) -> ([(a, Int)], Context)
tagItems (ys, ctx) = foldl f ([], ctx) ys
  where f (items, (Context x)) item = (items ++ [(item, x)], Context (x + 1))

main :: IO ()
main = do
  let ctx = Context 1000
      (items, ctx') = tagItems (["one", "two", "three"], ctx)
  putStrLn $ show items
-- Yields: [("one",1000),("two",1001),("three",1002)]

