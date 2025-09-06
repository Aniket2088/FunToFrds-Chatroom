# Use a base image with Ruby 2.3
FROM ruby:2.3.0

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs sqlite3 libsqlite3-dev

# Set working directory
WORKDIR /app

# Copy Gemfiles
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler -v 1.17.3
RUN bundle _1.17.3_ install

# Copy the rest of the app
COPY . .

# Precompile assets (if needed)
RUN bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Start Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
