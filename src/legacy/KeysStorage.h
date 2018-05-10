// Copyright (c) 2012-2017, The CryptoNote developers, The Bytecoin developers
//
// This file is part of Bytecoin.
//
// Bytecoin is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Bytecoin is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with Bytecoin.  If not, see <http://www.gnu.org/licenses/>.

#pragma once

#include "crypto/crypto.h"

#include <stdint.h>

namespace CryptoNote {

class ISerializer;

//! V1 wallet keys serialization structure
struct KeysStorage { 
  uint64_t creationTimestamp;

  crypto::public_key spendPublicKey;
  crypto::secret_key spendSecretKey;

  crypto::public_key viewPublicKey;
  crypto::secret_key viewSecretKey;

  void serialize(ISerializer& serializer, const std::string& name);
};
//!V6 wallet keys serialization structure
struct KeysStorageV6 {
	crypto::public_key publicKey;
	crypto::secret_key secretKey;
	uint64_t creationTimestamp;
	void serialize(ISerializer& serializer, const std::string& name);
	void serialize(ISerializer& serializer);
};

}
