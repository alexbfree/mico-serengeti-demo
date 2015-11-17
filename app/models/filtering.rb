module Filtering
  class SimpleFilter
    def initialize(filter)
      @filter = filter
    end

    def name
      @filter.to_s
    end

    def check(subject)
      send(@filter, subject)
    end

    private

    def entire_dataset(subject)
      true
    end

    def daytime(subject)
      [
        5191449, 5192012, 5204014, 5204441, 5210158, 5213826, 5214772, 5217794, 5219754, 5222644, 5233267, 5233359, 5233385, 5235360, 5243664, 5248079, 5249268, 5251701, 5253294, 5256555, 5262706, 5267763, 5271685, 5278484, 5287960, 5294295, 5316710, 5322950, 5334729, 5335006, 5338624, 5341029, 5344159, 5354949, 5363180, 5366959, 5368720, 5368764, 5374526, 5374749, 5375694, 5378714, 5379030, 5385361, 5385596, 5385699, 5386862, 5393421, 5402724, 5406810, 5416594, 5417454, 5435159, 5435487, 5436045, 5440933, 5450310, 5450637, 5454956, 5462696, 5464413, 5484904, 5487566, 5491520, 5494921, 5497791, 5498051, 5498321, 5513336, 5517753, 5522588, 5524986, 5528932, 5540890, 5542509, 5544027, 5552321, 5562391, 5568826, 5571920, 5575842, 5578098, 5580822, 5585282, 5592302, 5611221, 5611748, 5617837, 5621266, 5621300, 5632439, 5633922, 5638002, 5643929, 5653547, 5672140, 5675430, 5685607, 5690284, 5690427, 5692635, 5696012, 5699157, 5700745, 5707811, 5709486, 5713683, 5716583, 5723744, 5725518, 5727580, 5733791, 5740150, 5744590, 5750565, 5752353, 5753659, 5771084, 5780545, 5783735, 5786894, 5788504, 5793524, 5800312, 5806234, 5813708, 5820040, 5829566, 5834245, 5840889, 5847776, 5851073, 5857795, 5870568, 5883286, 5885398, 5891366, 5892448, 5894518, 5895299, 5900854, 5909702, 5921187, 5924089, 5925717, 5928901, 5936765, 5941142, 5946555, 5946642, 5948016, 5966014, 5979587, 5981340, 5987487, 5991486, 6001093, 6009560, 6010497, 6013709, 6014323, 6015923, 6026824, 6026916, 6035886, 6042520, 6042927, 6045459, 6052285, 6056698, 6060089, 6077554, 6081226, 6082028, 6084695, 6084823, 6086782, 6087574, 6100596, 6101389, 6101593, 6114628, 6115061, 6116539,
        5187788, 5189253, 5197405, 5202259, 5202369, 5208756, 5210168, 5211509, 5212310, 5212536, 5214537, 5221764, 5222646, 5244281, 5244824, 5250121, 5255240, 5255456, 5256550, 5258527, 5260628, 5275341, 5298711, 5307200, 5323923, 5325003, 5328276, 5334731, 5339965, 5340364, 5345975, 5351352, 5356675, 5359479, 5363594, 5364085, 5369502, 5375608, 5375956, 5377006, 5377679, 5378448, 5389256, 5390683, 5393561, 5400715, 5401652, 5407350, 5411856, 5413173, 5418097, 5423355, 5423931, 5429812, 5441148, 5449237, 5452463, 5466951, 5469738, 5471165, 5471764, 5472289, 5473059, 5475049, 5476841, 5477466, 5478031, 5478642, 5481961, 5482892, 5490532, 5495393, 5496606, 5499312, 5502072, 5502231, 5502617, 5514867, 5519537, 5524155, 5540443, 5543787, 5544739, 5549052, 5549847, 5551061, 5551365, 5556295, 5567828, 5571226, 5572462, 5576791, 5585909, 5589022, 5589484, 5594005, 5596394, 5617395, 5623844, 5623913, 5630397, 5631414, 5633350, 5635021, 5642905, 5647237, 5650081, 5656192, 5660336, 5677282, 5683180, 5688677, 5695485, 5710831, 5712062, 5724073, 5734398, 5740235, 5744304, 5751571, 5751898, 5754144, 5755352, 5781003, 5786522, 5790902, 5796937, 5798872, 5800616, 5814626, 5817040, 5827348, 5828520, 5832097, 5836300, 5838455, 5844299, 5845575, 5846068, 5848212, 5850892, 5854692, 5862455, 5863482, 5870586, 5872554, 5884323, 5888031, 5894451, 5900836, 5905598, 5906416, 5908002, 5918751, 5920636, 5935644, 5937802, 5945799, 5954759, 5960357, 5962906, 5974495, 5977771, 5977986, 5980263, 5996206, 6004594, 6018360, 6019444, 6023166, 6035659, 6039404, 6044538, 6054733, 6059342, 6064352, 6077837, 6089437, 6105310, 6106798, 6108819, 6111661, 6117967, 6122900
      ].include? subject.id
    end

    def nighttime(subject)
      [5157023, 5142124, 5156651, 5156671, 5140819, 5176367, 5151895, 5168130, 5149648, 5165024, 5144959, 5143376, 5201352, 5156675, 5143940, 5144149, 5176593, 5154669, 5171143, 5170562, 5168555, 5168595, 5167719, 5166380, 5146814, 5165186, 5164997, 5176424, 5141027, 5186703, 5141033, 5197734, 5141243, 5141991, 5161290, 5143935, 5144844, 5162788, 5147138, 5143992, 5161283, 5143527, 5143605, 5147009, 5156943, 5170632, 5145472, 5166367, 5170683, 5142047, 5162115, 5200729, 5192899, 5170731, 5140795, 5140804, 5140807, 5140810, 5140811, 5140812, 5140813, 5140815, 5140816, 5140817, 5140820, 5140821, 5140823, 5140824, 5140826, 5140827, 5140831, 5140832, 5140837, 5140838, 5140839, 5140842, 5140843, 5140846, 5140848, 5140850, 5140851, 5140852, 5140853, 5140854, 5140855, 5140856, 5140857, 5140858, 5140859, 5140860, 5140861, 5140862, 5140887, 5140891, 5140913, 5140927, 5140941, 5140944, 5140948, 5140951, 5140965, 5140970, 5141008, 5141019, 5141023, 5141034, 5141035, 5141036, 5141042, 5141051, 5141053, 5141054, 5141061, 5141064, 5141067, 5141076, 5141079, 5141080, 5141087, 5141089, 5141099, 5141102, 5141108, 5141110, 5141112, 5141113, 5141115, 5141116, 5141131, 5141132, 5141136, 5141137, 5141144, 5141153, 5141155, 5141157, 5141158, 5141161, 5141165, 5141172, 5141175, 5141182, 5141185, 5141190, 5141195, 5141196, 5141197, 5141199, 5141207, 5141210, 5141211, 5141213, 5141215, 5141216, 5141220, 5141222, 5141224, 5141226, 5141228, 5141237, 5141239, 5141950, 5141952, 5141953, 5141957, 5141963, 5141966, 5141969, 5141970, 5141972, 5141973, 5141974, 5141975, 5141976, 5141980, 5141988, 5141989, 5141992, 5141994, 5141997, 5142001, 5142004, 5142005, 5142008, 5142012, 5142017, 5142021, 5142023, 5142026, 5142028, 5142030, 5142042, 5142046].include?(subject.id)
    end

    def blank(subject)
      subject.consensus.crowd_says == 'blank'
    end

    def non_blank(subject)
      !blank(subject)
    end

    def one_animal(subject)
      subject.consensus.total_animals == 1
    end

    def simple(subject)
      subject.consensus.total_animals > 1 and subject.consensus.total_animals <= 5
    end

    def complex(subject)
      subject.consensus.total_animals > 5
    end

    def single_species(subject)
      subject.consensus.total_species == 1
    end

    def multi_species(subject)
      subject.consensus.total_species > 1
    end
  end

  class Only
    def initialize(species)
      @species = species
    end

    def name
      "only_#{@species}"
    end

    def check(subject)
      subject.consensus.crowd_says == @species
    end
  end

  class OnlyOther
    def initialize(species)
      @species = species
    end

    def name
      "only_other"
    end

    def check(subject)
      (["blank", "multi"] + @species).exclude? subject.consensus.crowd_says
    end
  end


  class MultiSpeciesIncluding
    def initialize(species)
      @species = species
    end

    def name
      "multi_including_#{@species}"
    end

    def check(subject)
      subject.consensus.crowd_says == "multi" && subject.consensus.species_found_by_crowd.include?(@species)
    end
  end

  class MultiOther
    def initialize(species)
      @species = species
    end

    def name
      "multi_including_none_of_the_five"
    end

    def check(subject)
      subject.consensus.crowd_says == "multi" && (subject.consensus.species_found_by_crowd & @species).empty?
    end
  end

end
