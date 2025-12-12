module Main where

import System.Directory (doesFileExist)
import System.Exit (exitFailure, exitSuccess)

main :: IO ()
main = do
  indexExists <- doesFileExist "dist/index.html"
  cssExists <- doesFileExist "dist/style.css"
  
  if indexExists && cssExists
    then do
      putStrLn "✅ All tests passed!"
      putStrLn "   - dist/index.html exists"
      putStrLn "   - dist/style.css exists"
      exitSuccess
    else do
      putStrLn "❌ Tests failed!"
      if not indexExists then putStrLn "   - dist/index.html is missing" else pure ()
      if not cssExists then putStrLn "   - dist/style.css is missing" else pure ()
      exitFailure
