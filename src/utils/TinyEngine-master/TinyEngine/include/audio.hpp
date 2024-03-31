#ifndef TINYENGINE_AUDIO
#define TINYENGINE_AUDIO

#include <deque>
#include <string>
#include <unordered_map>

#include "SDL_mixer.h"

class Audio {
public:
  bool enabled = false;

  std::unordered_map<std::string, Mix_Chunk *> sounds;
  std::deque<Mix_Chunk *> unprocessed;

  bool init();
  bool quit();

  void load(std::list<std::string> in);
  void play(std::string sound);
  void process();
};

#endif
