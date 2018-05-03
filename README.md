## asylo-site

This repository contains the source code for the [asylo.dev](https://asylo.dev) website.

Please see the main Asylo [README](https://github.com/google/asylo/blob/master/README.md)
file to learn about the overall Asylo project and how to get in touch with us.

* [Working with the site](#working-with-the-site)
* [Linting](#linting)
* [Thanks](#thanks)

## Working with the site

The website uses [Jekyll](https://jekyllrb.com/) templates Please make sure you are
familiar with these before editing.

To run the site locally with Docker, use the following command from the top level directory for this git repo
(e.g. pwd must be `~/github/asylo-site` if you were in `~/github` when you issued
`git clone https://github.com/google/asylo-site.git`)

```bash
# First time: (slow)
docker run --rm --label=asylo-jekyll --volume=$(pwd):/srv/jekyll -v $(pwd)/_site:$(pwd)/_site -it -p 127.0.0.1:4000:80 jekyll /jekyll:3.6.0 sh -c "bundle install && rake test && bundle exec jekyll serve --incremental --host 0.0.0.0"
# Then open browser with url 127.0.0.1:4000 to see the change.
# Subsequent, each time you want to see a new change and you stopped the previous run by ctrl+c: (much faster)
docker start asylo-jekyll -a -i
# Clean up, only needed if you won't be previewing website changes for a long time or you want to start over:
docker rm asylo-jekyll
```

The `rake test` part is to make sure you are not introducing HTML errors or bad links, you should see

```bash
HTML-Proofer finished successfully.
```

in the output

> In some cases the `--incremental` may not work properly and you might have to remove it.

Alternatively, if you just want to develop locally w/o Docker/Kubernetes/Minikube, you can try installing Jekyll locally.
You may need to install other prerequisites manually (which is where using the docker image shines). Here's an example of doing
so for Mac OS X:

```bash
xcode-select --install
sudo xcodebuild -license
brew install ruby
gem update --system
gem install mdspell
gem install bundler
gem install jekyll
cd asylo-site
bundle install
bundle exec rake test
bundle exec jekyll serve
```

## Linting

You should run `scripts/linters.sh` prior to checking in your changes.
This will run 3 tests:

* HTML proofing, which ensures all your links are valid along with other checks.

* Spell checking.

* Style checking, which makes sure your markdown file complies with some common style rules.

If you get a spelling error, you have three choices to address it:

* It's a real typo, so fix your markdown.

* It's a command/field/symbol name, so stick some `backticks` around it.

* It's really valid, so go add the word to the .spelling file at the root of the repo.

## Thanks

Many thanks to [@geeknoid](https://github.com/geeknoid) for his help basing this
website off the clean and elegant
[Istio.io](https://github.com/istio/istio.github.io/).
