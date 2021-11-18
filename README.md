# Abbyy
A basic command line app for Abbyy's OCR Service.

## Installation
Clone the repository:
```bash
git clone git@github.com:aquaflamingo/abbyy.git
```

Install dependencies
```bash
cd abbyy
bundle install 
```

## Usage
### Setting Up Credentials
The configuration class absorbs the Abbyy Cloud credentials from the environment variables, so set your shell environment up with these values prior to running the process:

```bash
export APP_ID=<your_id>
export APP_PASSWORD=<your_passowrd>
export APP_REGION=<your_region> # only EU supported atm
```

Alternatively, you can set up the values in the `scripts/example.env.sh` and simply `source` this file before hand (makes things easier, but, make sure you don't commit your credentials to version control!).


### Using the CLI
You can use the example data provided in `exampledata` folder, or provide your own file. Using the example data:
```bash
bundle exec exe/abbyy process exampledata/dead-souls.png > dead-souls-results.txt
```

The program will upload the `png` file to Abbyy's OCR cloud and perform recognition on it. Results are downloaded and sent to STDOUT. In the future, adding a flag for `OUTPUT` path would be cool. We can see the results by reading the file:

```bash
cat dead-souls-results.txt

"For what reason are you abusing me? An I in any way at fault for     
declining to play cards? Sell me those souls if you are the man to    
hesitate over such rubbish."                                          
"The foul fiend take you! I was about to have given them to you for   
nothing, but now you shan't have them at all---not if you offer me    
three kingdoms in exchange. Henceforth I will have nothing to do with 
you, you cobbler, you dirty blacksmith! Porphyri, go and tell the     
ostler to give the gentleman's horses no oats, but only hay."         
This development Chichikov had hardly expected.                       
"And do you," added Nozdrev to his guest, "get out of my sight."      
Yet in spite of this, host and guest took supper together--even though
on this occasion the table was adorned with no wines of fictitious    
nomenclature, but only with a bottle which reared its solitary head   
beside a jug of what is usually known as vin ordinaire. When supper   
was over Nozdrev said to Chichikov as he conducted him to a side room 
- --- had been made up:                                               
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

