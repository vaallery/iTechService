module PhoneTools

  # MTC
  # 70-72 => 790-792
  # 73-77 => 703-707

  PATTERNS = {
      '2480' => '79502990',
      '2481' => '79502991',
      '2482' => '79502992',
      '2483' => '79502993',
      '2484' => '79502994',
      '2485' => '79502995',
      '2486' => '79024856',
      '2487' => '79024857',
      '2488' => '79024858',
      '2489' => '79024859',
      '266'  => '7902480',
      '267'  => '7902481',
      '268'  => '7902482',
      '269'  => '7902483',
      '2780' => '79024840',
      '2781' => '79024841',
      '2782' => '79024842',
      '290'  => '7902505',
      '291'  => '7902506',
      '254'  => '7902524',
      '255'  => '7902555',
      '256'  => '7902556',
      '257'  => '7902557',
      '297'  => '7904627',
      '298'  => '7904628',
      '299'  => '7904629',
      '250'  => '7908440',
      '251'  => '7908441',
      '252'  => '7908442',
      '253'  => '7908443',
      '296'  => '7908446',
      '258'  => '7908448',
      '259'  => '7908449',
      '261'  => '7908991',
      '292'  => '7908992',
      '293'  => '7908993',
      '294'  => '7908994',
      '295'  => '7908995',
  }

  def self.convert_phone number
    full_number = nil
    unless number.blank?
      number = '2' + number if number.length == 6
      if number.length == 7
        patterns = PATTERNS.to_a
        i = 0
        while full_number.nil? and i < patterns.length do
          short = patterns[i][0]
          full = patterns[i][1]
          n = 7 - short.length
          rgxp = Regexp.new short+"(\\d{#{n}})"
          if rgxp === number
            base_digits = rgxp.match(number)[1]
            full_number = full + base_digits
          end
          i += 1
        end
        full_number ||= '7423'+number
      end
      full_number ||= '7'+number if number.length == 10
      full_number ||= '7'+number[1,10] if number.length == 11
    end
    full_number ||= ''
    [number, full_number]
  end

end