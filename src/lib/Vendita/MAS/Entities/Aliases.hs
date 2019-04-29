{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}

module Vendita.MAS.Entities.Aliases (
    Alias (..),
    listAllAliases,
    listAliases
) where

import Control.Monad.Reader
import Data.Aeson
import Data.UUID as UUID
import Data.UUID (UUID)
import Network.HTTP.Req ((=:))
import Vendita.MAS.Core

data Alias = Alias {
    aliasName :: String,
    aliasOf :: String,
    aliasType :: Maybe String,
    aliasDescription :: String
} deriving (Show)

instance Resource Alias where
    type Identifier Alias = String
    resourceIdentifier = aliasName
    resourcePathSegment = "alias"

instance NamedResource Alias where
    resourceName = aliasName

instance DescribedResource Alias where
    resourceDescription = aliasDescription

instance FromJSON Alias where
    parseJSON = withObject "object" $ \o -> do
        aliasName <- o .: "name"
        aliasOf <- o .: "alias"
        aliasType <- o .: "alias_type"
        aliasDescription <- o .: "description"
        return Alias{..}

listAllAliases :: MAS [Alias] 
listAllAliases = listAllResource

listAliases :: [Identifier Alias] -> MAS [Alias]
listAliases = listResourceWithIdentifiers 