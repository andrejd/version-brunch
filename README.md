## version-brunch
Adds application version support to
[brunch.io](http://brunch.io)

### Installation
Install plugin manually by adding text below to your package file inside your `brunch` application:

`"version-brunch": "https://github.com/AndrejD/version-brunch.git"`.

### Usage

Plugin will create `version.json` file inside brunch `public` folder where it
will store extended application version. Extended Application version is in sync
with `package.json` file and in addition it also contains build number.

```javascript
{
    "versionExt": "1.5.0.22"
}
```
Plugin also scans generated source files inside `public` folder after each bulid
and replaces `{!major!}` `{!minor!}` `{!maintenance!}` `{!build!}` strings with
parsed values from `version.json` file.

### Configuration

There are some options that allow changing plugin defaults. You can add these
settings to `brunch-config.json` file:

```coffeescript
config =
    plugins:
        version:
            versionFile: "version.json"
            fileRegExp: /(app\.js|index\.html)$/

```

After compilation all files in `public` folder are tested against `fileRegExp`
and if test passes, file is updated with version details. `versionFile` allows
changing file name where version details are persisted.

### Live reload and version-brunch

Build number is increased after every compilation process and output files in
`public` folder are  inspected after every compilation for version strings.

In case when style sheet changes triggered compilation process, script files do
not get regenerated and as a consequence version numbers in them points to the
previous build. Keep that in mind when using live reload in browser.




## License

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

