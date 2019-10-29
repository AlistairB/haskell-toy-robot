{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}

module TypesDep where

-- import           Control.Lens (makeLenses)

data Nat = Z | S Nat

data SmallerThan (limit :: Nat) where
  SmallerThanZ :: SmallerThan ('S any)
  SmallerThanS :: SmallerThan any -> SmallerThan ('S any)

data PositiveSmallerThan (limit :: Nat) where
  PSTOne :: PositiveSmallerThan ('S 'Z)
  PSTSmallerThan :: PositiveSmallerThan any -> PositiveSmallerThan ('S any)

data Board (boardSize :: Nat) = Board
  { _boardSize     :: PositiveSmallerThan boardSize
  , _boardRobot    :: Robot boardSize
  }

data Robot (boardSize :: Nat) = Robot
  { _robotPosition :: SmallerThanCoord boardSize
  }

data SmallerThanCoord (smallerThan :: Nat) = SmallerThanCoord
  { _stCoordinateX :: SmallerThan smallerThan
  , _stCoordinateY :: SmallerThan smallerThan
  }

board :: Board ('S ('S 'Z))
board =
  let robotCoord = SmallerThanCoord SmallerThanZ SmallerThanZ
      boardSize  = PSTSmallerThan PSTOne
  in  Board boardSize $ Robot $ robotCoord

instance Show (SmallerThan n) where
  show SmallerThanZ = "SmallerThanZ"
  show (SmallerThanS r) = "SmallerThanS (" ++ show r ++ ")"

-- data Direction' =
--   North'
-- | East'
-- | South'
-- | West'
-- deriving (Eq, Show, Enum)

-- data Coordinate' = Coordinate'
--   { _coordinateX :: Nat
--   , _coordinateY :: Nat
--   } deriving (Eq, Show)

-- data Command =
--     Move
--   | TurnLeft
--   | TurnRight
--   | Report
--   | Place Coordinate Direction
--   deriving (Eq, Show)

-- makeLenses ''Board
-- makeLenses ''Robot
-- makeLenses ''Coordinate
