#!/bin/bash
# Run smush combinations
# Usage:
#   smush-game-solver.sh <letters> <always_char> [used[,words...]] <hot_char>
# https://www.hankgreen.com/smush/

LETTERS="$1"
ALWAYS="$2"
if [[ $# == 3 ]]; then
  USED=""
  HOT="$3"
elif [[ $# == 4 ]]; then
  USED="$3"
  HOT="$4"
else
  echo "Usage: ${0##*/} <letters> <always_char> [used[,words...]] <hot_char>" 1>&2
  exit 1
fi

aspell dump master |
  awk "
    BEGIN {
      split(\"${USED}\", used_words, /,/)
      for (i in used_words) {
        delete chars
        split(used_words[i], chars, //)
        for (j in chars) {
          used_letters[chars[j]] += 1
        }
      }
      print \"score\", \"base_score\", \"multiplier\", \"hot\", \"smush\", \"pangram\", \"word\"
    }
    function wasUsed(_word) {
      for (_i in used_words) {
        if (used_words[_i] == _word) {
          return 1 == 1
        }
      }
      return 0 == 1
    }
    {
      empty = \"\"
      score = 0
      base_score = 0
      word = empty
      multiplier = 1
      smush = 0
      hot = 0
      pangram = 0
    }
    /^[${LETTERS}${ALWAYS}]+\$/ && /${ALWAYS}/ && length(\$0) >= 3 && !wasUsed(\$0) {
      word = \$0
      delete available
      delete chars
      split(\"${LETTERS}\", chars, //)
      for (i in chars) {
        available[chars[i]] = 5 - used_letters[chars[i]]
      }
      available[\"${ALWAYS}\"] = 100
      delete chars
      delete used
      split(word, chars, //)
      for (i in chars) {
        used[chars[i]] += 1
        available[chars[i]] -= 1
        if (available[chars[i]] < 0) {
          word = empty
          break
        } else if (available[chars[i]] == 0) {
          smush++
        }
      }
    }
    length(word) >= 3 {
      base_score = length(word)
      base_score += gsub(/[dg]/    , empty, word)
      base_score += gsub(/[bcmp]/  , empty, word) * 2
      base_score += gsub(/[fhvwy]/ , empty, word) * 3
      base_score += gsub(/k/       , empty, word) * 4
      base_score += gsub(/[jx]/    , empty, word) * 7
      base_score += gsub(/[qz]/    , empty, word) * 9
    }
    /${HOT}/{
      word = \$0;
      hot = gsub(/${HOT}/, empty, word)
    }
    base_score > 0 {
      if (length(used) == 9) {
        if (length(\"${LETTERS}\") == 40) {
          pangram = 4
        } else {
          pangram = 2
        }
      }
      multiplier += hot + smush + pangram
      score = base_score * multiplier
      word = \$0
      print score, base_score, multiplier, hot, smush, pangram, word | \"sort -n\"
    }
    END {
      close(\"sort -n\")
      print \"score\", \"base_score\", \"multiplier\", \"hot\", \"smush\", \"pangram\", \"word\"
    }
  "
