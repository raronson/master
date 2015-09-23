{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Master.Data (
    MasterConfig (..)
  , MasterJob (..)
  , MasterRunner (..)
  ) where

import           Data.Text

import           Mismi.S3

import           P

import           System.IO


data MasterConfig =
  MasterConfig {
    masterRunner :: MasterRunner
  , masterJobs :: [MasterJob]
  } deriving (Eq, Show)

data MasterJob =
  MasterJob {
    masterJobName :: Text
  , masterJobRunner :: Maybe MasterRunner
  , masterJobParams :: [(Text, Text)]
  } deriving (Eq, Show)

type Hash = Text

data MasterRunner =
    RunnerS3 Address (Maybe Hash)
  | RunnerPath FilePath
  deriving (Eq, Show)
