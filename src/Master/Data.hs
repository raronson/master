{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Master.Data (
    MasterConfig (..)
  , MasterJob (..)
  , MasterRunner (..)
  , MasterExecutable (..)
  , JobName (..)
  , MasterJobParams
  , Hash
  , masterJobSelect
  , masterRunnerRender
  , masterJobParamsRender
  ) where

import           Data.Map as M
import           Data.Text as T

import           Mismi.S3

import           P

import           System.FilePath

newtype JobName =
  JobName {
      jobName :: Text
    } deriving (Eq, Ord, Show)

newtype MasterExecutable =
  MasterExecutable {
      executable :: FilePath
    } deriving (Eq, Show)

data MasterConfig =
  MasterConfig {
    masterRunner :: MasterRunner
  , masterJobs :: Map JobName MasterJob
  } deriving (Eq, Show)

data MasterJob =
  MasterJob {
    masterJobRunner :: Maybe MasterRunner
  , masterJobParams :: MasterJobParams
  } deriving (Eq, Show)

type MasterJobParams = Map Text Text
type Hash = Text

data MasterRunner =
    RunnerS3 Address (Maybe Hash)
  | RunnerPath FilePath
  deriving (Eq, Show)


masterJobSelect :: Maybe JobName -> MasterConfig -> Maybe (MasterRunner, MasterJobParams)
masterJobSelect mjn (MasterConfig mr mjs) =
  maybe (Just (mr, M.empty)) (\jn ->
    (\(MasterJob mr' mj) -> (fromMaybe mr mr', mj)) <$> M.lookup jn mjs
    ) mjn

masterRunnerRender :: MasterRunner -> Text
masterRunnerRender = \case
  RunnerS3 a _ -> addressToText a
  RunnerPath p -> T.pack p

masterJobParamsRender :: MasterJobParams -> Text
masterJobParamsRender =
  T.intercalate "," . fmap (\(a, b) -> a <> "=" <> b) . M.toList
