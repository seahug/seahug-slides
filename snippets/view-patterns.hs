{-# LANGUAGE ViewPatterns #-}

-- Abstract type: data constructor would typically not be exported
data Widget = Widget String String
createWidget n d = Widget n d
widgetName (Widget n _) = n
widgetDesc (Widget _ d) = d

-- View type and function dependent only on public interface
data WidgetV = WidgetV String String
widgetV w = WidgetV n d where n = widgetName w; d = widgetDesc w

-- Function that pattern-matches on view
demo (widgetV -> WidgetV n d) = "name = " ++ n ++ " desc = " ++ d

main = putStrLn $ demo $ createWidget "name" "desc"

