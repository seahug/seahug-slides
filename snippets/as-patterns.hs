asPattern :: [a] -> [a]
asPattern xs@(x : xs') = xs

noAsPattern :: [a] -> [a]
noAsPattern (x : xs) = (x : xs)

