Feature: Receiving and returning devices

  As an authorized user
  I can receive and new devices for som service
  And return completed devices to client
  
  Scenario: Receiving device for some service
    Given a device
    When I enter correct initial data
    Then device should get an unique ticket number 
    And device tasks should contain chosen service
    And device location should match chosen service