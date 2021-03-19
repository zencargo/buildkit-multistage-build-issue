# Contents

- [bake.hcl](bake.hcl) - the targets that we build.
- [Dockerfile.main](Dockerfile.main) - the Dockerfile on the main branch, which builds fine.
- [Dockerfile.branch](Dockerfile.branch) - the Dockerfile on the problematic branch, which builds the `packs` stage multiple times if there is cache from the main branch build present.
- [without-cache.log](without-cache.log) - output from a successful build on the problematic branch after running `docker rm -f -v buildx_buildkit_default`; `packs` is only built once:
  - `#104 [production packs 1/1]`
- [with-cache.log](with-cache.log) - output from a failed build on the problematic branch after running the main branch build first; `packs` is built 4 times:
  - `#79 [production packs 1/1]`
  - `#129 [upload-elastic-beanstalk-application-version packs 1/1]`
  - `#160 [apollo-service-push packs 1/1]`
  - `#220 [upload-assets packs 1/1]`
