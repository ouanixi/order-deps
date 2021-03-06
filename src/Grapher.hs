{-# LANGUAGE OverloadedStrings #-}
module Grapher where

import           Data.Graph
import           Data.Text  (Text)
import           Jparse


type Atom = (Text, Text, Text)
type Graphable = [(Atom, Atom,[Atom])]


instance Show v => Show (SCC v) where
  show (AcyclicSCC v) = show [v]
  show (CyclicSCC lv) = show lv

-- Handles the case of the Json Key being a Maybe [ASTId]
extractAtoms :: Maybe [ASTId] -> [Atom]
extractAtoms (Just a)      = map (\ x -> (name x, modu x, package x)) a
extractAtoms _             = []


-- Turns a Json object into a tuple that's acceptable by graphFromEdges
extractGraphable :: ASTId -> (Atom , Atom, [Atom])
extractGraphable ASTId {
                        name = n,
                        modu = m,
                        package = p,
                        dependencies = d
                        } = ((n,m,p), (n,m,p), extractAtoms d)
