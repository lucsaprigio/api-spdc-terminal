object MonitorAPI: TMonitorAPI
  DisplayName = 'MonitorAPI'
  Height = 436
  Width = 574
  object Timer: TTimer
    Interval = 10000
    OnTimer = TimerTimer
    Left = 16
    Top = 24
  end
end
