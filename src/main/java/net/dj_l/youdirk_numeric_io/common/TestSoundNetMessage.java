/* This file is part of the `youdirk_numeric_io` Minecraft mod
 * Copyright (C) 2019  Dirk "YouDirk" Lehmann
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */


package net.dj_l.youdirk_numeric_io.common;
import net.dj_l.youdirk_numeric_io.*;

// Forge Mod Loader
import net.minecraftforge.fml.common.Mod;

// Network
import net.minecraft.network.PacketBuffer;

// Event Bus
import net.minecraftforge.eventbus.api.SubscribeEvent;

// Events
import net.minecraftforge.event.RegistryEvent;

// Gameplay
import net.minecraft.world.IWorld;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.SoundEvent;
import net.minecraft.util.SoundCategory;


/**
 * TODO: Just a TestMessage for networking.  Remove this class it if
 * tests are finished!
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
public class TestSoundNetMessage extends NetMessage<TestSoundNetMessage>
{
  @SubscribeEvent
  public static void
  onRegister(final RegistryEvent.Register<NetMessageBase> event)
  {
    event.getRegistry().register(new TestSoundNetMessage());
  }
  private static final String _REGISTRY_PATH = "test_sound_message";

  public final BlockPos POS;

  // May not exist on dedicated server
  public final ResourceLocation SOUND;

  public final SoundCategory CATEGORY;
  public final float VOLUME;
  public final float PITCH;

  /**
   * A default constructor without any parameter must be implemented
   * to instanciate dummy objects.  It can be empty, but
   * <code>super(String registryPath)</code> must be called.
   */
  public TestSoundNetMessage()
  {
    super(TestSoundNetMessage._REGISTRY_PATH);

    this.POS = null;
    this.SOUND = null;
    this.CATEGORY = null;
    this.VOLUME = 0.0f;
    this.PITCH = 0.0f;
  }

  public TestSoundNetMessage(BlockPos pos, ResourceLocation sound,
    SoundCategory category, float volume, float pitch)
  {
    super(TestSoundNetMessage._REGISTRY_PATH);

    this.POS = pos;
    this.SOUND = sound;
    this.CATEGORY = category;
    this.VOLUME = volume;
    this.PITCH = pitch;
  }


  @Override
  protected void encode(PacketBuffer buf)
  {
    buf.writeBlockPos(this.POS)
      .writeResourceLocation(this.SOUND)
      .writeString(this.CATEGORY.toString())
      .writeFloat(this.VOLUME)
      .writeFloat(this.PITCH);
  }

  @Override
  protected TestSoundNetMessage decode(PacketBuffer buf)
  {
    // THIS is a dummy instance!

    return new TestSoundNetMessage(
      buf.readBlockPos(),
      buf.readResourceLocation(),
      SoundCategory.valueOf(buf.readString(Net.STRLEN)),
      buf.readFloat(),
      buf.readFloat());
  }

  @Override
  protected void validateDecoded() throws NetPacketErrorException
  {
    /* If we are not on client side then RETURN and let throw an
     * exception in onReceiveServer().  You can also THROW here
     * instead of RETURN.
     */
    if (this.world == null) return;

    if (this.POS == null || !this.world.isBlockLoaded(this.POS))
      throw new NetPacketErrorException("Not a valid Block Position: "
                                        + this.POS);

    /* Would be better to really open the resource to test if it
     * exist, but too much CPU overhead.  In practise we should use
     * something like a Lookup Table and only transfer the Key over
     * the network.
     */
    if (this.SOUND == null || new SoundEvent(this.SOUND) == null)
      throw new NetPacketErrorException("Not a valid Sound Location: "
                                        + this.SOUND);

    if (this.CATEGORY == null || this.CATEGORY == SoundCategory.MASTER)
      throw new NetPacketErrorException("Not a valid Sound Category: "
                                        + this.CATEGORY);

    if (this.VOLUME < 0.0f || this.VOLUME > 1.0f)
      throw new NetPacketErrorException("Not a valid Sound Volume: "
                                        + this.VOLUME);

    if (this.PITCH <= 0.0f || this.PITCH > 50.0f)
      throw new NetPacketErrorException("Not a valid Sound Pitch: "
                                        + this.PITCH);
  }

  @Override
  protected void onReceiveServer() throws NetPacketErrorException
  {
    throw
      new NetPacketErrorException("No implementation on server side.");
  }

  @Override
  protected void onReceiveClient() throws NetPacketErrorException
  {
    YoudirkNumericIOEvent.post(
      new net.dj_l.youdirk_numeric_io.client.TestSoundEvent(this.world,
                                                            this));
  }
}
