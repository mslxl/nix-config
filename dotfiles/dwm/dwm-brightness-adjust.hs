import Data.Char
import Data.Maybe

import Control.Monad

import System.Environment

backlightPath :: String
backlightPath = "/sys/class/backlight/amdgpu_bl0"
step :: Int
step = 20

gpuFile :: String -> String
gpuFile ('/' : xs) = gpuFile xs
gpuFile x = backlightPath ++ '/' : x

str2Int :: String -> Int
str2Int xs = foldl1 (\pre acc -> pre * 10 + acc) $ fromJust <$> filter isJust (toNum <$> xs)
  where
    toNum x = if x `elem` nums then Just $ ord x - 48 else Nothing
    nums = ['0'..'9']

readFileToInt :: FilePath -> IO Int
readFileToInt file = str2Int <$> readFile (gpuFile file)

maxBrightness :: IO Int
maxBrightness = readFileToInt "max_brightness"

minBrightness :: IO Int
minBrightness = return 0

curBrightness :: IO Int
curBrightness = readFileToInt "brightness"

main :: IO()
main = do
  arg:xs <- getArgs
  cur <- curBrightness
  max <- maxBrightness
  min <- minBrightness
  let target = case arg of
        "up" -> if cur + step > max then max else cur + step
        "down" -> if cur - step < min then min else cur - step
        _ -> cur
  when (cur /= target) $ writeFile (gpuFile "brightness") $ show target
  when (cur == target) $ putStrLn "Target value is identical with current value, ignore it."
