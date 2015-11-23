# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

SHORT_WORDS = ['and', 'to', 'the']

CLASSIFICATION_DOMINANCE_THRESHOLD = 10
CLASSIFICATION_COMPLETE_THRESHOLD = 25
CLASSIFICATION_BLANK_THRESHOLD = 5

class window.FilterManager

  constructor: (query_string) ->
    query_string_parts = @getQueryPartsFromQueryString(query_string)
    @setFormFiltersFromQueryParts(query_string_parts)

  getQueryPartsFromQueryString: (queryString) =>
    search = queryString.substring(1);
    if search != ""
      JSON.parse '{"' + decodeURI(search).replace(/\"/g, '\\"').replace(/&/g, '","').replace(/\=/g, '":"') + '"}'
    else
      {}

  setFormFiltersFromQueryParts: (query_parts) =>
    @form_filters = {}
    for query_field, val of query_parts
      input_id = @getInputIdFromQueryField(query_field)
      @setFilter(input_id, val, false)
    @updateQueryParts()

  isRange: (val) =>
    val? && !!~val.toString().indexOf "-"

  isMin: (val) =>
    val? && !!~val.toString().indexOf "+"

  isExact: (val) =>
    val? && !@isRange(val) && !@isMin(val)

  setFilter: (input_id, val, update_query_parts = true) =>
    if (input_id == "drop-comment-status")
      if val == "has_no_data"
        @form_filters[input_id + "-has-no-data"] = val
      else if val == "has_data"
        @form_filters[input_id + "-has-data"] = val
      else if val == "unprocessed"
        @form_filters[input_id + "-unprocessed"] = val
      else
        @form_filters["drop-comment-status"] = val
    else if (input_id == "drop-status")
      if val == "unprocessed"
        @form_filters[input_id + "-unprocessed"] = val
      else
        @form_filters[input_id] = val
    else if @isMin(val)
      @form_filters[input_id + "-min"] = val.replace(/\+/g, '')
    else if @isRange(val)
      min_and_max = val.split "-"
      min = min_and_max[0]
      max = min_and_max[1]
      @form_filters[input_id + "-min"] = min
      @form_filters[input_id + "-max"] = max
    else
      @form_filters[input_id] = val
    if update_query_parts
      @updateQueryParts()

  getCommentAnalysisDisplayTextFromStatus: (comment_status) =>
    switch comment_status
      when "has_no_data" then "No comment analysis data stored"
      when "has_data" then "Has comment analysis data stored"
      when "unprocessed" then "Comments not yet analysed"
      when "finished" then "Comments successfully analysed"
      when "submitting" then "Comments being processed"
      when "failed" then "Comment analysis failed"
      else
        "Comment analysis unclear"

  getImageAnalysisDisplayTextFromStatus: (status) =>
    switch status
      when "unprocessed" then "Image not yet analysed"
      when "finished" then "Image successfully analysed"
      when "submitting" then "Image being processed"
      when "failed" then "Image analysis failed"
      when "zfailed" then "Image analysis failed (old)"
      else
        "Image analysis unclear"

  getInputIdFromQueryField: (query_field) =>
    switch query_field
      when "status" then "drop-status"
      when "status_unprocessed" then "drop-status-unprocessed"
      when "dataset" then "drop-dataset"
      when "entity" then "drop-entity"
      when "light" then "drop-light"
      when "roll_id" then "drop-roll-code"
      when "site_id" then "drop-site-id"
      when "number_of_regions" then "drop-regions"
      when "number_of_regions_min" then "drop-regions-min"
      when "number_of_regions_max" then "drop-regions-max"
      when "total_species" then "drop-total-species"
      when "total_species_min" then "drop-total-species-min"
      when "total_species_max" then "drop-total-species-max"
      when "total_animals" then "drop-total-animals"
      when "total_animals_min" then "drop-total-animals-min"
      when "total_animals_max" then "drop-total-animals-max"
      when "number_of_comments" then "drop-number-of-comments"
      when "number_of_comments_min" then "drop-number-of-comments-min"
      when "number_of_comments_max" then "drop-number-of-comments-max"
      when "species" then "drop-species"
      when "comment_status" then "drop-comment-status"
      when "comment_status_unprocessed" then "drop-comment-status-unprocessed"
      when "has_comment_analysis_data" then "drop-comment-status-has-data"
      when "has_no_comment_analysis_data" then "drop-comment-status-has-no-data"

  getQueryFieldFromModifiedInputId: (input_id) =>
    switch input_id
      when "drop-light" then "light"
      when "drop-roll-code" then "roll_id"
      when "drop-site-id" then "site_id"
      when "drop-number-of-comments" then "number_of_comments"
      when "drop-number-of-comments-min" then "number_of_comments_min"
      when "drop-number-of-comments-max" then "number_of_comments_max"
      when "drop-regions" then "number_of_regions"
      when "drop-regions-min" then "number_of_regions_min"
      when "drop-regions-max" then "number_of_regions_max"
      when "drop-total-animals" then "total_animals"
      when "drop-total-animals-min" then "total_animals_min"
      when "drop-total-animals-max" then "total_animals_max"
      when "drop-total-species" then "total_species"
      when "drop-total-species-min" then "total_species_min"
      when "drop-total-species-max" then "total_species_max"
      when "drop-status" then "status"
      when "drop-status-unprocessed" then "status_unprocessed"
      when "drop-comment-status" then "comment_status"
      when "drop-comment-status-unprocessed" then "comment_status_unprocessed"
      when "drop-comment-status-has-data" then "has_comment_analysis_data"
      when "drop-comment-status-has-no-data" then "has_no_comment_analysis_data"
      when "drop-species" then "species"

  # update query parts from raw form inputs
  updateQueryParts: () =>
    @query_parts = {}
    for input_id, val of @form_filters
      @query_parts[@getQueryFieldFromModifiedInputId(input_id)] = val

  getFilterClass: (query_field) =>
    switch query_field
      when "status", "dataset", "number_of_regions", "number_of_regions_max", "number_of_regions_min", "entities", "comment_status", "comment_status_unprocessed", "has_no_comment_analysis_data", "has_comment_analysis_data"
        "mico-filter"
      else
        "zoo-filter"

  getFilterDisplayText: (query_field, val) =>
    switch query_field
      when "species"
        if val == "blank"
          "blank (no animals present)"
        else if val == "multi"
          "multiple species present"
        else
          "1 or more " + FilterManager.getHumanFriendlySpecies(val) + " present"
      when "number_of_regions"
        if val == 1
          "exactly 1 animal found"
        else
          "exactly " + val + " animals found"
      when "number_of_regions_min" then val + " or more animals found"
      when "number_of_regions_max" then val + " or fewer animals found"
      when "number_of_comments" then "exactly " + val + " comments present"
      when "number_of_comments_min" then val + " or more comments present"
      when "number_of_comments_max" then val + " or fewer comments present"
      when "total_species" then "exactly " + val + " species present"
      when "total_species_min" then val + " or more species present"
      when "total_species_max" then val + " or fewer species present"
      when "total_animals"
        if val == 1
          "exactly 1 animal present"
        else
          "exactly " + val + " animals present"
      when "total_animals_min" then val + " or more animals present"
      when "total_animals_max" then val + " or fewer animals present"
      when "site_id" then "site " + val
      when "roll_id" then "roll " + val
      when "light" then "taken during the " + val
      when "has_no_comment_analysis_data" then @getCommentAnalysisDisplayTextFromStatus val
      when "has_comment_analysis_data" then @getCommentAnalysisDisplayTextFromStatus val
      when "comment_status" then @getCommentAnalysisDisplayTextFromStatus val
      when "comment_status_unprocessed" then @getCommentAnalysisDisplayTextFromStatus val
      when "status" then @getImageAnalysisDisplayTextFromStatus val
      when "status_unprocessed" then @getImageAnalysisDisplayTextFromStatus val

  getURLQueryString: =>
    @updateQueryParts()
    query_string = ""
    for query_field, val of @query_parts
      if query_string.length > 0
        query_string += "&"
      query_string += query_field + "=" + val
    "?" + query_string

  getFilterDrawerHTML: =>
    @updateQueryParts()
    html = ""
    if @isFiltered()
      for query_field, val of @query_parts
        html += "<span data-query-field='" + query_field + "' class='filter-pill " + @getFilterClass(query_field) + "'>"
        html += @getFilterDisplayText(query_field, val)
        html += "</span>"
    else
      html = '<span class="no-filters">No filters currently applied.</span>'
    html

  isFiltered: =>
    !!(Object.keys(@form_filters).length > 0)

  removeAllFilters: (renderCallback, renderCallbackParameter) =>
    @form_filters = {}
    @updateQueryParts()
    if typeof renderCallback == "function"
      renderCallback(renderCallbackParameter)

# remove a filter for a field (which may have been modified with -min or -max on the end)
  removeFilterByQueryField: (query_field, renderCallback, renderCallbackParameter) =>
    input_id = @getInputIdFromQueryField(query_field)
    delete @form_filters[input_id]
    @updateQueryParts()
    if typeof renderCallback == "function"
      renderCallback(renderCallbackParameter)

  @getCountersEntryFromKeysAndValuesArray: (counters_keys, counters_values) =>
    counters = {}
    counters_keys = counters_keys.split ";"
    counters_values = counters_values.split ";"
    for key, index in counters_keys
      value = parseInt(counters_values[index])
      counters[key]=value
    counters

  @pluralize: (number, singular, plural) ->
    if number > 1 or number is 0 then plural else singular

  @getHumanFriendlySpecies: (species, count = 2) ->
    if species in ['wildebeest', 'buffalo', 'impala', 'hartebeest', 'topi']
      species
    else if species in ['elephant', 'warthog', 'reedbuck', 'human', 'giraffe', 'waterbuck',
                        'aardvark', 'bushbuck', 'cheetah', 'baboon', 'jackal', 'serval',
                        'bat', 'caracal', 'civet', 'duiker', 'genet', 'hare', 'leopard',
                        'mongoose', 'porcupine', 'steenbok', 'eland', 'vulture', 'wildcat',
                        'zorilla', 'zebra']
      @pluralize(count, species, species + 's')
    else if species in ['hippopotamus', 'rhinoceros', 'ostrich']
      @pluralize(count, species, species + 'es')
    else if species is 'cattle'
      @pluralize(count, 'cow', 'cattle')
    else if species in ['reptiles', 'rodents']
      @pluralize(count, species.slice(0, -1), species)
    else if species is 'gazellethomsons'
      @pluralize(count, "Thomson's gazelle", "Thomson's gazelles")
    else if species is 'gazellegrants'
      @pluralize(count, "Grant's gazelle", "Grant's gazelles")
    else if species is 'otherbird'
      @pluralize(count, "bird (other)", "birds (other)")
    else if species is 'dikdik'
      @pluralize(count, "dik-dik", "dik-diks")
    else if species is 'honeybadger'
      @pluralize(count, "honey badger", "honey badgers")
    else if species is 'hyenaspotted'
      "spotted hyena"
    else if species is 'hyenastriped'
      "striped hyena"
    else if species is 'lionfemale'
      @pluralize(count, "female lion", "female lions")
    else if species is 'lionmale'
      @pluralize(count, "male lion", "male lions")
    else if species is 'guineafowl'
      "guineafowl"
    else if species is 'koribustard'
      @pluralize(count, "kori bustard", "kori bustards")
    else if species is 'batearedfox'
      @pluralize(count, "bat-eared fox", "bat-eared foxes")
    else if species is 'aardwolf'
      @pluralize(count, "aardwolf", "aardwolves")
    else if species is 'secretarybird'
      @pluralize(count, "secretary bird", "secretary birds")
    else if species is 'insectspider'
      @pluralize(count, "spider or insect", "spiders or insects")
    else if species is 'vervetmonkey'
      @pluralize(count, "vervet monkey", "vervet monkeys")
    else if species is 'blank'
      'blank'
    else
      @pluralize(count, species, species + 's')

  @getConsensusSpeciesMessage: (consensus) =>
    specieses = consensus.crowd_says_if_multi.split ";"
    for shortcode, index in specieses
      specieses[index] = @getHumanFriendlySpecies(shortcode)
    if specieses.length > 1
      species_list = (specieses.slice(0, -1).join ", ") + " and " + specieses.slice().pop()
    else
      species_list = specieses[0]
    "<br/> By consensus, this subject contains "+species_list

  @buildCrowdData: (subject, consensus) =>
    crowdData = {}
    classification_count = consensus.classifications
    counters = @getCountersEntryFromKeysAndValuesArray consensus.counters_keys, consensus.counters_values
    crowdData.allClassificationData = @getAllClassifications counters
    crowdData.maxClassificationID = @getMaxClassificationID counters
    crowdData.maxClassificationData = {}
    crowdData.maxClassificationData.voters = 0
    crowdData.active = false
    if (crowdData.maxClassificationID)
      crowdData.maxClassificationVoters = counters[crowdData.maxClassificationID]
      crowdData.maxClassificationData = @getClassificationDataFromCountersEntry crowdData.maxClassificationID, crowdData.maxClassificationVoters
      crowdData.maxClassificationNumberOfDifferentSpecies = crowdData.maxClassificationData.speciesData.length
      crowdData.dominantClassificationID = @getDominantClassificationID counters, CLASSIFICATION_DOMINANCE_THRESHOLD
      if classification_count >= CLASSIFICATION_COMPLETE_THRESHOLD
        crowdData.state = "complete"
        crowdData.message = "This subject has been completely classified." + @getConsensusSpeciesMessage(consensus)
      else if classification_count == 0
        crowdData.active = true
        crowdData.state = "unclassified"
        crowdData.message = "This subject has yet to be classified."
        crowdData.min_classifications_needed = CLASSIFICATION_DOMINANCE_THRESHOLD
      else if crowdData.dominantClassificationID
        crowdData.dominantClassificationVoters = counters[crowdData.dominantClassificationID]
        crowdData.dominantClassificationData = @getClassificationDataFromCountersEntry crowdData.dominantClassificationID, crowdData.dominantClassificationVoters
        crowdData.dominantClassificationNumberOfDifferentSpecies = Object.keys(crowdData.dominantClassificationData.speciesData).length
        if crowdData.dominantClassificationID == 'blank'
          crowdData.state = "blank_by_consensus"
          crowdData.message = "The crowd has reached agreement that there are no animals present in this subject."
        else
          if crowdData.dominantClassificationNumberOfDifferentSpecies == 1
            crowdData.dominantClassificationSoleSpeciesID = crowdData.dominantClassificationID
            crowdData.dominantClassificationSoleSpeciesName = @getHumanFriendlySpecies crowdData.dominantClassificationID
            crowdData.state = "one_sole_species_by_consensus"
            crowdData.message = "The crowd has reached agreement that this subject contains one or more "+crowdData.dominantClassificationSoleSpeciesName
          else
            crowdData.state = "several_species_by_consensus"
            crowdData.message = "The crowd has reached agreement on which species are present. " + @getConsensusSpeciesMessage(consensus)
      else
        if counters.hasOwnProperty 'blank'
          if Object.keys(counters).length == 1
            if counters['blank'] < CLASSIFICATION_BLANK_THRESHOLD
              crowdData.active = true
              crowdData.state = "active_but_nearly_blank"
              crowdData.message = "The crowd is still classifying this subject, but so far it appears to contain no animals."
              crowdData.min_classifications_needed = CLASSIFICATION_BLANK_THRESHOLD - counters['blank']
            else
              crowdData.state = "unanimously_blank"
              crowdData.message = "The crowd unanimously agrees that this subject contains no animals."
          else
            if Object.keys(counters).length == 2
              crowdData.active = true
              crowdData.state = "active_either_blank_or_agreed_animals"
              crowdData.message = "The crowd is still classifying this subject. There is disagreement as to whether any animals are present, but not as to which species are present."
              crowdData.min_classifications_needed = CLASSIFICATION_DOMINANCE_THRESHOLD - crowdData.maxClassificationData.voters
            else
              crowdData.active = true
              crowdData.state = "active_either_blank_or_uncertain_animals"
              crowdData.message = "The crowd is still classifying this subject. There is disagreement as to whether any animals are present, and as to which species are present."
              crowdData.min_classifications_needed = CLASSIFICATION_DOMINANCE_THRESHOLD - crowdData.maxClassificationData.voters
        else
          if Object.keys(counters).length == 1
            crowdData.active = true
            crowdData.state = "active_but_agreed_animals"
            crowdData.message = "The crowd is still classifying this subject. There does seem to be one or more animals present. So far, there is agreement upon which species are present." + @getConsensusSpeciesMessage(consensus)
            crowdData.min_classifications_needed = CLASSIFICATION_DOMINANCE_THRESHOLD - crowdData.maxClassificationData.voters
          else
            crowdData.active = true
            crowdData.state = "active_but_uncertain_animals"
            crowdData.message = "The crowd is still classifying this subject. There does seem to be one or more animals present. There is disagreement as to which species are present."
            crowdData.min_classifications_needed = CLASSIFICATION_DOMINANCE_THRESHOLD - crowdData.maxClassificationData.voters
    else
      crowdData.active = true
      crowdData.state = "active_unknown"
      crowdData.message = "This subject has not yet been classified by anyone. Nothing is known about this image from the crowd's perspective."
      crowdData.min_classifications_needed = CLASSIFICATION_DOMINANCE_THRESHOLD
    crowdData

  @getMaxClassificationID: (metadata_counters) ->
    for maxKey of metadata_counters
      break
    for key of metadata_counters
      if metadata_counters.hasOwnProperty key
        if metadata_counters[key] > metadata_counters[maxKey]
          maxKey = key
    maxKey

  @getDominantClassificationID: (metadata_counters, threshold = CLASSIFICATION_DOMINANCE_THRESHOLD) ->
    maxClassification = @getMaxClassificationID metadata_counters
    if metadata_counters[maxClassification] >= threshold
      maxClassification
    else
      false

  @getSpeciesDataForClassificationID: (classificationID) ->
    specieses = classificationID.split '-'
    speciesData = {}
    for species in specieses
        speciesId = species
        speciesName = @getHumanFriendlySpecies species
        speciesData[speciesId] = speciesName
    speciesData

  @getClassificationDataFromCountersEntry: (combinedClassificationID, voters) ->
    classification = {}
    classification.speciesData = @getSpeciesDataForClassificationID combinedClassificationID
    classification.voters = voters
    classification

  @getAllClassifications: (metadata_counters) ->
    classifications = []
    for combinedClassificationID, voters of metadata_counters
      classifications.push @getClassificationDataFromCountersEntry combinedClassificationID, voters
    classifications
