#!/usr/bin/env bash
eval "$(rbenv init -)"
cd /Users/Shared/labels
bundle exec ruby generate.rb
